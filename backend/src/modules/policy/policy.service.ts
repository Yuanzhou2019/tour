import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Policy } from './entities/policy.entity';

@Injectable()
export class PolicyService {
  constructor(
    @InjectRepository(Policy)
    private readonly policyRepo: Repository<Policy>,
  ) {}

  async list(query: { country?: string; reason?: string; city?: string; category?: string }) {
    const qb = this.policyRepo.createQueryBuilder('p');
    if (query.country) qb.andWhere('p.country = :country', { country: query.country });
    if (query.reason) qb.andWhere('p.reason = :reason', { reason: query.reason });
    if (query.category) qb.andWhere('p.category = :category', { category: query.category });
    qb.orderBy('p.category', 'ASC').addOrderBy('p.updatedAt', 'DESC');
    const data = await qb.getMany();
    return { data };
  }

  async findById(id: string) {
    const policy = await this.policyRepo.findOne({ where: { id } });
    if (!policy) throw new NotFoundException(`Policy ${id} not found`);
    return policy;
  }

  async create(dto: Partial<Policy>) {
    const entity = this.policyRepo.create(dto);
    return this.policyRepo.save(entity);
  }

  async update(id: string, dto: Partial<Policy>) {
    const result = await this.policyRepo.update(id, dto);
    if (result.affected === 0) throw new NotFoundException(`Policy ${id} not found`);
    return this.findById(id);
  }

  async delete(id: string) {
    const result = await this.policyRepo.delete(id);
    if (result.affected === 0) throw new NotFoundException(`Policy ${id} not found`);
    return { deleted: true };
  }
}
