# 🚀 No Task Required

**Just a task list made with Flutter and NestJS for practice**

---

## 📋 Index

- [About](#-about)
- [Technologies Used](#-Technologies-Used)
- [Requirements](#-Requirements)
- [Installation and Running Locally](#-Installation-and-Running-Locally)

---

## 📖 About

The **No Task Required** project is an application built for the purpose of practicing system development using Flutter and NestJS; it allows users to register daily tasks, track their execution and completion, and view tasks created on other days.

---

## 🛠 Technologies Used

The main tools and frameworks used in the construction of this system was:

* **Front-End:** [Flutter]
* **Back-End:** [Node.js / Typescript / NestJS / Prisma]
* **Database:** [SQLite]

---

## ⚙️ Requirements

Before you begin, verify that the following tools are installed on your machine:

* [Git](https://git-scm.com)
* [Node.js](https://nodejs.org/) (version 26.13.0 or higher)
* [Flutter](https://flutter.dev/) (version 3.47.5 or higher)

---

## 🚀 Installation and Running Locally

Follow the steps below to run the project locally:

### 1. Clone the repository

Open a terminal on the folder you want do clone the repository

```bash
git clone https://github.com/alansousap/no_task_required.git
cd no_task_required
```

### 2. Install dependencies from Back-End

```bash
cd back
npm i
```

### 3. Set the envirement variables

Copy the example file:

```bash
cp .env.example .env
```

To run this project, you will need to add the followings variables:

| Variable | Description | Example |
| :---: | :---: | :---: |
| `DATABASE_URL` | The path to the database file | `file:./database/[database_name].db`

### 4. Configure the database with Prisma

Run the command below to create the database e run the migrations:

```bash
npx prisma migrate dev
```

Run the following command to generate the prisma client:

```bash
npx prisma generate
```

### 5. Run the Back-End Server

```bash
npm run start
```

The server will start on `http://localhost:3000`, if you need to change the port, set on the .env file a variable `PORT` with the desire port.

### 6. Install dependencies from Front-End

Open a new terminal to the folder `front` of the clone repository

```bash
flutter pub get
```

### 7. Run the Flutter application

```bash
flutter run -d chrome
```