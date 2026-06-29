import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { DiscoverCard } from './entities/discover-card.entity';
import { Rank } from './entities/rank.entity';

@Injectable()
export class DiscoverService {
  constructor(
    @InjectRepository(DiscoverCard) private cardRepo: Repository<DiscoverCard>,
    @InjectRepository(Rank) private rankRepo: Repository<Rank>,
  ) {}

  async getCategory(category: 'curated' | 'authentic' | 'heads_up') {
    const data = await this.cardRepo.find({
      where: { category },
      order: { order: 'ASC' },
    });
    return { data };
  }

  async getRanksByCategory(category: string) {
    const data = await this.rankRepo.find({
      where: { category: category as Rank['category'] },
      order: { order: 'ASC' },
    });
    return { data };
  }

  async getRankById(category: string, rankId: string) {
    const rank = await this.rankRepo.findOne({
      where: { id: rankId, category: category as Rank['category'] },
    });
    if (!rank) throw new NotFoundException(`Rank ${rankId} in ${category} not found`);
    return rank;
  }
}