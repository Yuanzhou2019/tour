import { Controller, Get } from '@nestjs/common';
import { PoiService } from './poi.service';

@Controller('pois')
export class PoiController {
  constructor(private readonly poiService: PoiService) {}

  @Get()
  list() {
    return this.poiService.list();
  }
}
