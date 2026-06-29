import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { AuthService } from './auth.service';

export interface JwtPayload {
  sub: string;
  username: string;
  role: string;
}

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private readonly authService: AuthService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: process.env.JWT_SECRET || 'sightour-dev-secret-change-in-production',
    });
  }

  async validate(payload: JwtPayload) {
    const admin = await this.authService.validateUser(payload.sub);
    if (!admin) throw new UnauthorizedException();
    return { id: admin.id, username: admin.username, role: admin.role };
  }
}
