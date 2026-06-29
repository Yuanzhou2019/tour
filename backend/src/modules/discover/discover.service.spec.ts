import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { NotFoundException } from '@nestjs/common';
import { DiscoverService } from './discover.service';
import { DiscoverCard } from './entities/discover-card.entity';
import { Rank } from './entities/rank.entity';

describe('DiscoverService', () => {
  let service: DiscoverService;
  const mockCardRepo = {
    find: jest.fn(),
  };
  const mockRankRepo = {
    find: jest.fn(),
    findOne: jest.fn(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DiscoverService,
        { provide: getRepositoryToken(DiscoverCard), useValue: mockCardRepo },
        { provide: getRepositoryToken(Rank), useValue: mockRankRepo },
      ],
    }).compile();
    service = module.get<DiscoverService>(DiscoverService);
  });

  describe('getCategory', () => {
    it('should return cards for a valid category', async () => {
      const cards = [
        { id: '1', title: 'Card 1', category: 'curated' },
        { id: '2', title: 'Card 2', category: 'curated' },
      ];
      mockCardRepo.find.mockResolvedValue(cards);

      const result = await service.getCategory('curated');

      expect(result.data).toEqual(cards);
      expect(mockCardRepo.find).toHaveBeenCalledWith({
        where: { category: 'curated' },
        order: { order: 'ASC' },
      });
    });

    it('should handle authentic category', async () => {
      mockCardRepo.find.mockResolvedValue([]);

      const result = await service.getCategory('authentic');

      expect(result.data).toEqual([]);
    });

    it('should handle heads_up category', async () => {
      mockCardRepo.find.mockResolvedValue([{ id: '3' }]);

      const result = await service.getCategory('heads_up');

      expect(result.data).toHaveLength(1);
    });
  });

  describe('getRanksByCategory', () => {
    it('should return ranks for a category', async () => {
      const ranks = [
        { id: 'r1', category: 'dining', items: [] },
        { id: 'r2', category: 'dining', items: [] },
      ];
      mockRankRepo.find.mockResolvedValue(ranks);

      const result = await service.getRanksByCategory('dining');

      expect(result.data).toEqual(ranks);
      expect(mockRankRepo.find).toHaveBeenCalledWith({
        where: { category: 'dining' },
        order: { order: 'ASC' },
      });
    });

    it('should return empty if no ranks found', async () => {
      mockRankRepo.find.mockResolvedValue([]);

      const result = await service.getRanksByCategory('shopping');

      expect(result.data).toEqual([]);
    });
  });

  describe('getRankById', () => {
    it('should return a rank by id and category', async () => {
      const rank = { id: 'r1', category: 'dining', items: [] };
      mockRankRepo.findOne.mockResolvedValue(rank);

      const result = await service.getRankById('dining', 'r1');

      expect(result).toEqual(rank);
      expect(mockRankRepo.findOne).toHaveBeenCalledWith({
        where: { id: 'r1', category: 'dining' },
      });
    });

    it('should throw NotFoundException when not found', async () => {
      mockRankRepo.findOne.mockResolvedValue(null);

      await expect(service.getRankById('dining', 'not-found')).rejects.toThrow(
        NotFoundException,
      );
    });
  });
});
