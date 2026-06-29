import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { FxRate } from './entities/fx-rate.entity';
import { EmergencyContact } from './entities/emergency-contact.entity';
import { Phrase } from './entities/phrase.entity';

@Injectable()
export class ToolsService {
  constructor(
    @InjectRepository(FxRate) private fxRepo: Repository<FxRate>,
    @InjectRepository(EmergencyContact) private emergencyRepo: Repository<EmergencyContact>,
    @InjectRepository(Phrase) private phraseRepo: Repository<Phrase>,
  ) {}

  async getFxRate(from: string, to: string) {
    const rate = await this.fxRepo.findOne({ where: { fromCurrency: from, toCurrency: to } });
    if (!rate) {
      // Try inverse: USD -> CNY exists, so CNY -> USD = 1/that
      const inverse = await this.fxRepo.findOne({ where: { fromCurrency: to, toCurrency: from } });
      if (inverse) {
        return { from, to, rate: 1 / inverse.rate, computed: true, updatedAt: inverse.updatedAt };
      }
      throw new NotFoundException(`No FX rate for ${from}->${to}`);
    }
    return rate;
  }

  async listAllFxRates() {
    return { data: await this.fxRepo.find() };
  }

  async listEmergency(country?: string) {
    const where = country ? { country } : {};
    const data = await this.emergencyRepo.find({ where, order: { type: 'ASC' } });
    return { data };
  }

  async listPhrasesByCategory(category: string) {
    const data = await this.phraseRepo.find({
      where: { category: category as Phrase['category'] },
      order: { order: 'ASC' },
    });
    return { data };
  }

  async listAllPhrases() {
    return { data: await this.phraseRepo.find({ order: { category: 'ASC', order: 'ASC' } }) };
  }

  async createEmergency(dto: Partial<EmergencyContact>) {
    const entity = this.emergencyRepo.create(dto);
    return this.emergencyRepo.save(entity);
  }

  async updateEmergency(id: string, dto: Partial<EmergencyContact>) {
    const result = await this.emergencyRepo.update(id, dto);
    if (result.affected === 0) throw new NotFoundException(`EmergencyContact ${id} not found`);
    return this.emergencyRepo.findOne({ where: { id } });
  }

  async deleteEmergency(id: string) {
    const result = await this.emergencyRepo.delete(id);
    if (result.affected === 0) throw new NotFoundException(`EmergencyContact ${id} not found`);
    return { deleted: true };
  }

  async createPhrase(dto: Partial<Phrase>) {
    const entity = this.phraseRepo.create(dto);
    return this.phraseRepo.save(entity);
  }

  async updatePhrase(id: string, dto: Partial<Phrase>) {
    const result = await this.phraseRepo.update(id, dto);
    if (result.affected === 0) throw new NotFoundException(`Phrase ${id} not found`);
    return this.phraseRepo.findOne({ where: { id } });
  }

  async deletePhrase(id: string) {
    const result = await this.phraseRepo.delete(id);
    if (result.affected === 0) throw new NotFoundException(`Phrase ${id} not found`);
    return { deleted: true };
  }
}