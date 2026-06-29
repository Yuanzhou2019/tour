import { Entity, PrimaryColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('users')
export class User {
  @PrimaryColumn({ length: 64 })
  anonymousId!: string;

  @Column({ length: 16, default: 'en' })
  locale!: string;

  @Column({ length: 16, default: 'system' })
  theme!: string;

  @Column({ length: 16, default: 'metric' })
  unit!: string;

  @Column({ length: 8, nullable: true })
  country?: string;

  @Column({ length: 32, nullable: true })
  entryReason?: string;

  @Column({ length: 16, nullable: true })
  entryCity?: string;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
