import { Controller, Get } from '@nestjs/common';
import { ContentPackService } from './content-pack.service';

@Controller('content-packs')
export class ContentPackController {
  constructor(private readonly contentPackService: ContentPackService) {}

  @Get()
  list() {
    return this.contentPackService.list();
  }
}
