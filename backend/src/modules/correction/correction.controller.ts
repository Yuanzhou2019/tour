import { Body, Controller, Get, Headers, Param, Patch, Post } from '@nestjs/common';
import { CorrectionService, CreateCorrectionDto } from './correction.service';

@Controller('corrections')
export class CorrectionController {
  constructor(private readonly correctionService: CorrectionService) {}

  @Post()
  async create(
    @Headers('x-anonymous-id') anonymousId: string,
    @Body() dto: CreateCorrectionDto,
  ) {
    if (!anonymousId) {
      anonymousId = `anon-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
    }
    return this.correctionService.create(anonymousId, dto);
  }

  @Get()
  list() {
    return this.correctionService.listAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.correctionService.findById(id);
  }

  @Patch(':id')
  update(
    @Param('id') id: string,
    @Body() body: { status: 'reviewing' | 'resolved' | 'rejected'; reviewNote?: string; reviewerId?: string },
  ) {
    return this.correctionService.updateStatus(id, body.status, body.reviewNote, body.reviewerId);
  }
}