import { CallHandler, ExecutionContext, Injectable, NestInterceptor, Logger } from '@nestjs/common';
import { Observable, from, switchMap, of } from 'rxjs';
import { UserService } from '../../modules/user/user.service';

@Injectable()
export class AnonymousIdInterceptor implements NestInterceptor {
  private readonly logger = new Logger(AnonymousIdInterceptor.name);

  constructor(private readonly userService: UserService) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const req = context.switchToHttp().getRequest();
    const anonymousId = req.headers['x-anonymous-id'] as string | undefined;
    if (!anonymousId) {
      return next.handle();
    }
    // Fire-and-forget: ensure user exists, don't block the request
    this.userService.upsertAnonymous(anonymousId).catch((err) => {
      this.logger.warn(`Failed to upsert anonymous user ${anonymousId}: ${err.message}`);
    });
    return next.handle();
  }
}
