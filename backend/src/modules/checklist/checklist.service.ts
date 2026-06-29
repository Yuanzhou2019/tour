import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Checklist, ChecklistItem } from './entities/checklist.entity';

export interface ToggleItemDto {
  itemId: string;
  checked: boolean;
}

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

  async toggleItem(id: string, dto: ToggleItemDto) {
    const checklist = await this.checklistRepo.findOne({ where: { id } });
    if (!checklist) throw new NotFoundException(`Checklist ${id} not found`);

    const items: ChecklistItem[] = checklist.items.map((item) =>
      item.id === dto.itemId ? { ...item, checked: dto.checked } : item,
    );

    await this.checklistRepo.update(id, { items } as any);
    return { ...checklist, items };
  }

  async create(dto: Partial<Checklist>) {
    const entity = this.checklistRepo.create(dto);
    return this.checklistRepo.save(entity);
  }

  async update(id: string, dto: Partial<Checklist>) {
    const result = await this.checklistRepo.update(id, dto);
    if (result.affected === 0) throw new NotFoundException(`Checklist ${id} not found`);
    return this.findById(id);
  }

  async delete(id: string) {
    const result = await this.checklistRepo.delete(id);
    if (result.affected === 0) throw new NotFoundException(`Checklist ${id} not found`);
    return { deleted: true };
  }
}