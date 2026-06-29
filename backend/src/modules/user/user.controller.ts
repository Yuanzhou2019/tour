import { Body, Controller, Get, Headers, Param, Patch, Post } from '@nestjs/common';
import { UserService, UpdatePreferencesDto } from './user.service';

@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Post('anon')
  createAnon(
    @Headers('x-anonymous-id') anonymousId: string,
    @Body() prefs: UpdatePreferencesDto,
  ) {
    const id = anonymousId || `anon-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
    return this.userService.upsertAnonymous(id, prefs);
  }

  @Get('anon/:id')
  findOne(@Param('id') id: string) {
    return this.userService.findByAnonymousId(id);
  }

  @Patch('anon/:id')
  update(@Param('id') id: string, @Body() prefs: UpdatePreferencesDto) {
    return this.userService.upsertAnonymous(id, prefs);
  }
}
