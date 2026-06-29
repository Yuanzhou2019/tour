import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, Index } from 'typeorm';

@Entity('policies')
@Index(['country', 'reason', 'category'])
export class Policy {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ length: 8 })
  country!: string; // ISO 3166-1 alpha-2: US, GB, JP, ...

  @Column({ length: 32 })
  reason!: string; // tourism | business | family_visit | education | work | transit

  @Column({ length: 32 })
  category!: string; // visa_free | visa_required | transit | customs | consular | residence

  @Column({ length: 200 })
  titleZh!: string;

  @Column({ length: 200 })
  titleEn!: string;

  @Column({ type: 'text' })
  contentZh!: string;

  @Column({ type: 'text' })
  contentEn!: string;

  @Column({ length: 500, nullable: true })
  sourceUrl?: string;

  @Column({ length: 200, nullable: true })
  sourceName?: string;

  @Column({ type: 'date' })
  updatedAt!: string;

  @CreateDateColumn()
  createdAt!: Date;
}