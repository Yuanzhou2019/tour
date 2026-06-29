import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { scryptSync, randomBytes, timingSafeEqual } from 'crypto';
import { AdminUser } from './entities/admin-user.entity';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(AdminUser)
    private readonly adminRepo: Repository<AdminUser>,
    private readonly jwtService: JwtService,
  ) {}

  async login(username: string, password: string) {
    const admin = await this.adminRepo.findOne({ where: { username } });
    if (!admin) throw new UnauthorizedException('Invalid credentials');

    const [salt, storedHash] = admin.passwordHash.split(':');
    const inputHash = scryptSync(password, salt, 64).toString('hex');
    const inputBuffer = Buffer.from(inputHash, 'hex');
    const storedBuffer = Buffer.from(storedHash, 'hex');

    if (
      inputBuffer.length !== storedBuffer.length ||
      !timingSafeEqual(inputBuffer, storedBuffer)
    ) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const payload = { sub: admin.id, username: admin.username, role: admin.role };
    return {
      accessToken: this.jwtService.sign(payload),
      user: { id: admin.id, username: admin.username, role: admin.role },
    };
  }

  async validateUser(id: string): Promise<AdminUser | null> {
    return this.adminRepo.findOne({ where: { id } });
  }

  /** Seed 用：生成密码哈希 */
  static hashPassword(password: string): string {
    const salt = randomBytes(16).toString('hex');
    const hash = scryptSync(password, salt, 64).toString('hex');
    return `${salt}:${hash}`;
  }
}
