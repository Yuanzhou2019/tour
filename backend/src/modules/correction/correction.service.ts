import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Correction } from './entities/correction.entity';

export interface CreateCorrectionDto {
  type: 'content_error' | 'policy' | 'poi' | 'phrase' | 'other';
  targetId?: string;
  message: string;
  contactEmail?: string;
}

@Injectable()
export class CorrectionService {
  constructor(
    @InjectRepository(Correction)
    private readonly correctionRepo: Repository<Correction>,
  ) {}

  async create(anonymousId: string, dto: CreateCorrectionDto) {
    const entity = this.correctionRepo.create({
      anonymousId,
      type: dto.type,
      targetId: dto.targetId,
      message: dto.message,
      contactEmail: dto.contactEmail,
      status: 'queued',
    });
    return this.correctionRepo.save(entity);
  }

  async listAll() {
    return { data: await this.correctionRepo.find({ order: { createdAt: 'DESC' } }) };
  }

  async findById(id: string) {
    const c = await this.correctionRepo.findOne({ where: { id } });
    if (!c) throw new NotFoundException(`Correction ${id} not found`);
    return c;
  }

  async updateStatus(id: string, status: 'reviewing' | 'resolved' | 'rejected', reviewNote?: string, reviewerId?: string) {
    const result = await this.correctionRepo.update(id, { status, reviewNote, reviewerId });
    if (result.affected === 0) throw new NotFoundException(`Correction ${id} not found`);
    return this.findById(id);
  }
}