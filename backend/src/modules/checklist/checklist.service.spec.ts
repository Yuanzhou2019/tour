import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { NotFoundException } from '@nestjs/common';
import { ChecklistService } from './checklist.service';
import { Checklist } from './entities/checklist.entity';

describe('ChecklistService', () => {
  let service: ChecklistService;
  const mockQueryBuilder = {
    andWhere: jest.fn().mockReturnThis(),
    orderBy: jest.fn().mockReturnThis(),
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
        ChecklistService,
        { provide: getRepositoryToken(Checklist), useValue: mockRepo },
      ],
    }).compile();
    service = module.get<ChecklistService>(ChecklistService);
  });

  describe('list', () => {
    it('should filter by country, reason, city', async () => {
      const items = [{ id: '1', country: 'US' }];
      mockQueryBuilder.getMany.mockResolvedValue(items);

      const result = await service.list({
        country: 'US',
        reason: 'tourism',
        city: 'SH',
      });

      expect(result.data).toEqual(items);
      expect(mockQueryBuilder.andWhere).toHaveBeenCalledTimes(3);
    });

    it('should return empty data with no filters', async () => {
      mockQueryBuilder.getMany.mockResolvedValue([]);
      const result = await service.list({});
      expect(result.data).toEqual([]);
    });
  });

  describe('findById', () => {
    it('should return a checklist when found', async () => {
      const checklist = { id: 'abc', title: 'Test Checklist' };
      mockRepo.findOne.mockResolvedValue(checklist);

      const result = await service.findById('abc');

      expect(result).toEqual(checklist);
    });

    it('should throw NotFoundException when not found', async () => {
      mockRepo.findOne.mockResolvedValue(null);

      await expect(service.findById('not-found')).rejects.toThrow(
        NotFoundException,
      );
    });
  });
});
