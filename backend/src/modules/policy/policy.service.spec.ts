import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { NotFoundException } from '@nestjs/common';
import { PolicyService } from './policy.service';
import { Policy } from './entities/policy.entity';

describe('PolicyService', () => {
  let service: PolicyService;
  const mockQueryBuilder = {
    andWhere: jest.fn().mockReturnThis(),
    orderBy: jest.fn().mockReturnThis(),
    addOrderBy: jest.fn().mockReturnThis(),
    getMany: jest.fn().mockResolvedValue([]),
  };
  const mockRepo = {
    createQueryBuilder: jest.fn(() => mockQueryBuilder),
    findOne: jest.fn(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PolicyService,
        { provide: getRepositoryToken(Policy), useValue: mockRepo },
      ],
    }).compile();
    service = module.get<PolicyService>(PolicyService);
  });

  describe('list', () => {
    it('should return data from query builder', async () => {
      const policies = [{ id: '1', country: 'US' }];
      mockQueryBuilder.getMany.mockResolvedValue(policies);

      const result = await service.list({ country: 'US' });

      expect(result.data).toEqual(policies);
      expect(mockRepo.createQueryBuilder).toHaveBeenCalledWith('p');
      expect(mockQueryBuilder.andWhere).toHaveBeenCalledWith(
        'p.country = :country',
        { country: 'US' },
      );
    });

    it('should filter by multiple params', async () => {
      await service.list({ country: 'US', reason: 'tourism', category: 'visa_free' });

      expect(mockQueryBuilder.andWhere).toHaveBeenCalledTimes(3);
    });

    it('should return empty data when no filters', async () => {
      mockQueryBuilder.getMany.mockResolvedValue([]);
      const result = await service.list({});
      expect(result.data).toEqual([]);
    });
  });

  describe('findById', () => {
    it('should return a policy when found', async () => {
      const policy = { id: 'abc', title: 'Test' };
      mockRepo.findOne.mockResolvedValue(policy);

      const result = await service.findById('abc');

      expect(result).toEqual(policy);
      expect(mockRepo.findOne).toHaveBeenCalledWith({ where: { id: 'abc' } });
    });

    it('should throw NotFoundException when not found', async () => {
      mockRepo.findOne.mockResolvedValue(null);

      await expect(service.findById('not-found')).rejects.toThrow(
        NotFoundException,
      );
    });
  });
});
