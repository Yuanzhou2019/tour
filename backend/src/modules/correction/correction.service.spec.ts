import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { NotFoundException } from '@nestjs/common';
import { CorrectionService } from './correction.service';
import { Correction } from './entities/correction.entity';

describe('CorrectionService', () => {
  let service: CorrectionService;
  const mockCorrectionRepo = {
    create: jest.fn(),
    save: jest.fn(),
    find: jest.fn(),
    findOne: jest.fn(),
    update: jest.fn(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CorrectionService,
        { provide: getRepositoryToken(Correction), useValue: mockCorrectionRepo },
      ],
    }).compile();
    service = module.get<CorrectionService>(CorrectionService);
  });

  describe('create', () => {
    it('should create a correction with queued status', async () => {
      const dto = {
        type: 'content_error' as const,
        message: 'Wrong info',
        contactEmail: 'user@test.com',
      };
      const entity = {
        anonymousId: 'anon-1',
        ...dto,
        status: 'queued',
      };
      mockCorrectionRepo.create.mockReturnValue(entity);
      mockCorrectionRepo.save.mockResolvedValue({ ...entity, id: 'corr-1' });

      const result = await service.create('anon-1', dto);

      expect(mockCorrectionRepo.create).toHaveBeenCalledWith({
        anonymousId: 'anon-1',
        type: 'content_error',
        message: 'Wrong info',
        contactEmail: 'user@test.com',
        status: 'queued',
      });
      expect(result.id).toBe('corr-1');
    });

    it('should create a correction without optional fields', async () => {
      const dto = { type: 'poi' as const, message: 'Address wrong' };
      const entity = {
        anonymousId: 'anon-2',
        type: 'poi',
        message: 'Address wrong',
        status: 'queued',
      };
      mockCorrectionRepo.create.mockReturnValue(entity);
      mockCorrectionRepo.save.mockResolvedValue({ ...entity, id: 'corr-2' });

      const result = await service.create('anon-2', dto);

      expect(result.status).toBe('queued');
    });
  });

  describe('listAll', () => {
    it('should return all corrections ordered by createdAt DESC', async () => {
      const corrections = [{ id: '1' }, { id: '2' }];
      mockCorrectionRepo.find.mockResolvedValue(corrections);

      const result = await service.listAll();

      expect(result.data).toEqual(corrections);
      expect(mockCorrectionRepo.find).toHaveBeenCalledWith({
        order: { createdAt: 'DESC' },
      });
    });
  });

  describe('findById', () => {
    it('should return a correction when found', async () => {
      const correction = { id: 'abc', message: 'Test' };
      mockCorrectionRepo.findOne.mockResolvedValue(correction);

      const result = await service.findById('abc');

      expect(result).toEqual(correction);
    });

    it('should throw NotFoundException when not found', async () => {
      mockCorrectionRepo.findOne.mockResolvedValue(null);

      await expect(service.findById('not-found')).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('updateStatus', () => {
    it('should update status and return the correction', async () => {
      mockCorrectionRepo.update.mockResolvedValue({ affected: 1 });
      const updated = { id: 'abc', status: 'resolved', reviewNote: 'Fixed' };
      mockCorrectionRepo.findOne.mockResolvedValue(updated);

      const result = await service.updateStatus('abc', 'resolved', 'Fixed');

      expect(mockCorrectionRepo.update).toHaveBeenCalledWith('abc', {
        status: 'resolved',
        reviewNote: 'Fixed',
        reviewerId: undefined,
      });
      expect(result.status).toBe('resolved');
    });

    it('should throw NotFoundException when update affects 0 rows', async () => {
      mockCorrectionRepo.update.mockResolvedValue({ affected: 0 });

      await expect(service.updateStatus('not-found', 'resolved')).rejects.toThrow(
        NotFoundException,
      );
    });
  });
});
