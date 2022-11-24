import { BaseEntity, Column, CreateDateColumn, Entity, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { User } from './user.entity';
import { Device } from './device.entity';

@Entity()
export class Measurement extends BaseEntity {

  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User)
  user: User;

  @Column()
  temperature: number;

  @Column()
  humidity: number;

  @Column()
  takenAt: Date;

  @CreateDateColumn()
  createdAt: Date;
}
