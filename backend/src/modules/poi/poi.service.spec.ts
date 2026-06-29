import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { NotFoundException } from '@nestjs/common';
import { PoiService } from './poi.service';
import { Poi } from './entities/poi.entity';
import { PoiReputation } from './entities/poi-reputation.entity';
import { PoiTag } from './entities/poi-tag.entity';

describe('PoiService', () => {
  let service: PoiService;
  const mockQueryBuilder = {
    andWhere: jest.fn().mockReturnThis(),
    orderBy: jest.fn().mockReturnThis(),
    limit: jest.fn().mockReturnThis(),
    getMany: jest.fn().mockResolvedValue([]),
  };
  const mockPoiRepo = {
    createQueryBuilder: jest.fn(() => mockQueryBuilder),
    findOne: jest.fn(),
  };
  const mockRepRepo = {
    findOne: jest.fn(),
  };
  const mockTagRepo = {};

  beforeEach(async () => {
    jest.clearAllMocks();
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PoiService,
        { provide: getRepositoryToken(Poi), useValue: mockPoiRepo },
        { provide: getRepositoryToken(PoiReputation), useValue: mockRepRepo },
        { provide: getRepositoryToken(PoiTag), useValue: mockTagRepo },
      ],
    }).compile();
    service = module.get<PoiService>(PoiService);
  });

  describe('search', () => {
    it('should return empty data by default', async () => {
      const result = await service.search({});
      expect(result.data).toEqual([]);
    });

    it('should filter by city and category', async () => {
      mockQueryBuilder.getMany.mockResolvedValue([]);
      await service.search({ city: 'SH', category: 'attraction' });

      expect(mockQueryBuilder.andWhere).toHaveBeenCalledTimes(2);
    });

    it('should search by keyword', async () => {
      mockQueryBuilder.getMany.mockResolvedValue([{ id: '1' }]);
      await service.search({ q: 'temple' });

      expect(mockQueryBuilder.andWhere).toHaveBeenCalledTimes(1);
    });

    it('should limit results to 50', async () => {
      await service.search({});
      expect(mockQueryBuilder.limit).toHaveBeenCalledWith(50);
    });
  });

  describe('findById', () => {
    it('should return a poi with relations', async () => {
      const poi = { id: 'abc', name: 'Test POI', tags: [], reputation: null };
      mockPoiRepo.findOne.mockResolvedValue(poi);

      const result = await service.findById('abc');

      expect(result).toEqual(poi);
      expect(mockPoiRepo.findOne).toHaveBeenCalledWith({
        where: { id: 'abc' },
        relations: ['tags', 'reputation'],
      });
    });

    it('should throw NotFoundException when not found', async () => {
      mockPoiRepo.findOne.mockResolvedValue(null);

      await expect(service.findById('not-found')).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('getReputation', () => {
    it('should return reputation for a poi', async () => {
      const rep = { id: 'rep1', overallScore: 4.5 };
      mockRepRepo.findOne.mockResolvedValue(rep);

      const result = await service.getReputation('poi1');

      expect(result).toEqual(rep);
      expect(mockRepRepo.findOne).toHaveBeenCalledWith({
        where: { poi: { id: 'poi1' } },
      });
    });

    it('should throw NotFoundException when not found', async () => {
      mockRepRepo.findOne.mockResolvedValue(null);

      await expect(service.getReputation('poi1')).rejects.toThrow(
        NotFoundException,
      );
    });
  });
});
