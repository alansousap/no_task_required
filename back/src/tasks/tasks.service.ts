import { BadRequestException, Injectable, NotFoundException } from "@nestjs/common";
import { PrismaService } from "../prisma/prisma.service.js";
import { Tasks } from '../generated/prisma/client.js';

@Injectable()
export class TasksService {
    constructor(private readonly prisma: PrismaService) {}

    async createTask(description: string): Promise<Tasks> {
        const isTaskExist = await this.prisma.tasks.findFirst({ where: { description } });
        if (isTaskExist){
            throw new BadRequestException('Task already created');
        }

        const dateISO = new Date().toISOString().split('T')[0];
        const newDate = new Date(`${dateISO}T00:00:00.000Z`);

        const task = await this.prisma.tasks.create({
            data: {
                description,
                completed: false,
                iniciated: false,
                date: newDate,
            }
        });

        return task;
    }

    async findTasksWithDate(date: string): Promise<Tasks[]> {
        const dateToSearch = new Date(`${date}T00:00:00.000Z`);

        const tasks = await this.prisma.tasks.findMany({
            where: {
                date: dateToSearch
            }
        });
        
        return tasks;
    }

    async updateStatusTask(id: number, iniciated: boolean, completed: boolean): Promise<Tasks> {

        try {
            const updatedTask = await this.prisma.tasks.update({
                where: { id },
                data: { iniciated, completed }
            });

            return updatedTask;
        } catch (err) {
            throw new NotFoundException('Task not found');
        }

    }

}