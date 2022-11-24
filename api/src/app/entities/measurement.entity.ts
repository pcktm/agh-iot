import { BaseEntity, Column, CreateDateColumn, Entity, Index, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { LaundrySession } from './laundrySession.entity';

@Entity()
export class Measurement extends BaseEntity {

  @PrimaryGeneratedColumn()
  id: string;

  @Index()
  @ManyToOne(() => LaundrySession, laundrySession => laundrySession.measurements)
  laundrySession: LaundrySession;

  @Column()
  temperature: number;

  @Column()
  humidity: number;

  @CreateDateColumn()
  createdAt: Date;
}
