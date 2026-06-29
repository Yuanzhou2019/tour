import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, Index } from 'typeorm';

@Entity('corrections')
@Index(['status'])
export class Correction {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ length: 64 })
  anonymousId!: string;

  @Column({ length: 32 })
  type!: 'content_error' | 'policy' | 'poi' | 'phrase' | 'other';

  @Column({ length: 200, nullable: true })
  targetId?: string;

  @Column({ type: 'text' })
  message!: string;

  @Column({ length: 200, nullable: true })
  contactEmail?: string;

  @Column({ length: 16, default: 'queued' })
  status!: 'queued' | 'reviewing' | 'resolved' | 'rejected';

  @Column({ length: 64, nullable: true })
  reviewerId?: string;

  @Column({ type: 'text', nullable: true })
  reviewNote?: string;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
