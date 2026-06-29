import { Entity, PrimaryGeneratedColumn, Column, Index } from 'typeorm';

@Entity('emergency_contacts')
@Index(['country', 'type'])
export class EmergencyContact {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ length: 8, default: '*' })
  country!: string; // * 通用，否则 ISO

  @Column({ length: 16 })
  type!: 'police' | 'medical' | 'fire' | 'consulate' | 'tourist_hotline';

  @Column({ length: 200 })
  nameZh!: string;

  @Column({ length: 200 })
  nameEn!: string;

  @Column({ length: 50 })
  phone!: string;

  @Column({ length: 500, nullable: true })
  addressZh?: string;

  @Column({ length: 500, nullable: true })
  addressEn?: string;
}
