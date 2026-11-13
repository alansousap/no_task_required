import { Controller, Get, Post, Body, UsePipes, ValidationPipe, Param, Patch, ParseIntPipe } from '@nestjs/common';
import { CreateTaskDto } from './dto/create_task.dto.js';
import { TasksService } from './tasks.service.js';
import { Tasks } from '../generated/prisma/client.js';
import { findTasksWithDateParamDto } from './dto/find_tasks_with_date_param.dto.js';
import { UpdateStatusTaskDto } from './dto/update_status_task.dto.js';

@Controller("tasks")
export class TasksController {
    constructor(private readonly service:TasksService) {}

    @Post()
    @UsePipes(ValidationPipe)
    async create(@Body() createTaskDto: CreateTaskDto): Promise<Tasks> {
        const description = createTaskDto.description;

        const task = await this.service.createTask(description);

        return task;
    }

    @Get(':date')
    @UsePipes(ValidationPipe)
    async findTasksWithDate(@Param() params: findTasksWithDateParamDto): Promise<Tasks[]> {
        const date = params.date;
        
        const tasks = await this.service.findTasksWithDate(date);

        return tasks;
    }

    @Patch(':id')
    async updateStatusTask(@Param('id', ParseIntPipe) id: number, @Body(ValidationPipe) updateStatusTask: UpdateStatusTaskDto): Promise<Tasks> {
        const iniciated = updateStatusTask.iniciated;
        const completed = updateStatusTask.completed;

        const updatedTask = await this.service.updateStatusTask(id, iniciated, completed);

        return updatedTask;
    }
}
