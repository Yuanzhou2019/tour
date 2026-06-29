import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Poi } from './entities/poi.entity';
import { PoiReputation } from './entities/poi-reputation.entity';
import { PoiTag } from './entities/poi-tag.entity';

@Injectable()
export class PoiService {
  constructor(
    @InjectRepository(Poi) private poiRepo: Repository<Poi>,
    @InjectRepository(PoiReputation) private repRepo: Repository<PoiReputation>,
    @InjectRepository(PoiTag) private tagRepo: Repository<PoiTag>,
  ) {}

  async search(q: { q?: string; category?: string; city?: string }) {
    const qb = this.poiRepo.createQueryBuilder('p');
    if (q.city) qb.andWhere('p.city = :city', { city: q.city });
    if (q.category) qb.andWhere('p.category = :category', { category: q.category });
    if (q.q) {
      qb.andWhere('(p.nameZh ILIKE :kw OR p.nameEn ILIKE :kw OR p.addressZh ILIKE :kw OR p.addressEn ILIKE :kw)', {
        kw: `%${q.q}%`,
      });
    }
    qb.orderBy('p.nameEn', 'ASC').limit(50);
    return { data: await qb.getMany() };
  }

  async findById(id: string) {
    const poi = await this.poiRepo.findOne({
      where: { id },
      relations: ['tags', 'reputation'],
    });
    if (!poi) throw new NotFoundException(`POI ${id} not found`);
    return poi;
  }

  async getReputation(poiId: string) {
    const rep = await this.repRepo.findOne({ where: { poi: { id: poiId } } });
    if (!rep) throw new NotFoundException(`Reputation for ${poiId} not found`);
    return rep;
  }
}