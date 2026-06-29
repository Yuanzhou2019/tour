import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';

export interface UpdatePreferencesDto {
  locale?: string;
  theme?: string;
  unit?: string;
  country?: string;
  entryReason?: string;
  entryCity?: string;
}

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
  ) {}

  async upsertAnonymous(anonymousId: string, prefs: UpdatePreferencesDto = {}) {
    let user = await this.userRepo.findOne({ where: { anonymousId } });
    if (!user) {
      user = this.userRepo.create({
        anonymousId,
        locale: prefs.locale ?? 'en',
        theme: prefs.theme ?? 'system',
        unit: prefs.unit ?? 'metric',
        country: prefs.country,
        entryReason: prefs.entryReason,
        entryCity: prefs.entryCity,
      });
    } else if (Object.keys(prefs).length > 0) {
      Object.assign(user, prefs);
    }
    return this.userRepo.save(user);
  }

  async findByAnonymousId(anonymousId: string) {
    const user = await this.userRepo.findOne({ where: { anonymousId } });
    if (!user) throw new NotFoundException(`User ${anonymousId} not found`);
    return user;
  }
}
