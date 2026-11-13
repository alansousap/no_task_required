-- CreateTable
CREATE TABLE "Tasks" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "description" TEXT NOT NULL,
    "date" DATETIME NOT NULL,
    "completed" BOOLEAN NOT NULL,
    "iniciated" BOOLEAN NOT NULL
);
