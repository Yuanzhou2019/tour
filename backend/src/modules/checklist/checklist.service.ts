import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Checklist } from './entities/checklist.entity';

@Injectable()
export class ChecklistService {
  constructor(
    @InjectRepository(Checklist)
    private readonly checklistRepo: Repository<Checklist>,
  ) {}

  async list(query: { country?: string; reason?: string; city?: string }) {
    const qb = this.checklistRepo.createQueryBuilder('c');
    if (query.country) qb.andWhere('c.country = :country', { country: query.country });
    if (query.reason) qb.andWhere('c.reason = :reason', { reason: query.reason });
    if (query.city) qb.andWhere('c.city = :city', { city: query.city });
    qb.orderBy('c.titleEn', 'ASC');
    const data = await qb.getMany();
    return { data };
  }

  async findById(id: string) {
    const checklist = await this.checklistRepo.findOne({ where: { id } });
    if (!checklist) throw new NotFoundException(`Checklist ${id} not found`);
    return checklist;
  }
}