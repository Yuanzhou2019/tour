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

  async createCard(dto: Partial<DiscoverCard>) {
    const entity = this.cardRepo.create(dto);
    return this.cardRepo.save(entity);
  }

  async updateCard(id: string, dto: Partial<DiscoverCard>) {
    const result = await this.cardRepo.update(id, dto);
    if (result.affected === 0) throw new NotFoundException(`DiscoverCard ${id} not found`);
    return this.cardRepo.findOne({ where: { id } });
  }

  async deleteCard(id: string) {
    const result = await this.cardRepo.delete(id);
    if (result.affected === 0) throw new NotFoundException(`DiscoverCard ${id} not found`);
    return { deleted: true };
  }

  async createRank(dto: Partial<Rank>) {
    const entity = this.rankRepo.create(dto);
    return this.rankRepo.save(entity);
  }

  async updateRank(id: string, dto: Partial<Rank>) {
    const result = await this.rankRepo.update(id, dto);
    if (result.affected === 0) throw new NotFoundException(`Rank ${id} not found`);
    return this.rankRepo.findOne({ where: { id } });
  }

  async deleteRank(id: string) {
    const result = await this.rankRepo.delete(id);
    if (result.affected === 0) throw new NotFoundException(`Rank ${id} not found`);
    return { deleted: true };
  }
}