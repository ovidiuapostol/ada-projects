--  main.adb
--  Procedure: Main
--  Purpose  : Entry point of the application. Elaborates the Scheduler
--             package, which starts the periodic tasks (FSM tick and
--             renderer update). Prints a startup message.
--  Author   : Ovi
with Ada.Text_IO; use Ada.Text_IO;
with Scheduler;   -- Ensures that the periodic tasks are elavborated before Main runs
procedure Main is

begin
   Put_Line ("Program Run");
   null;
end Main;
