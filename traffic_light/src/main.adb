--------------------------------------------------------------------------
--  main.adb
--  Procedure: Main
--  Purpose  : Entry point of the application. Elaborates the Scheduler
--             package, which starts the periodic tasks (FSM tick and
--             renderer update). Prints a startup message.
--  Author   : Ovi
---------------------------------------------------------------------------

with World_Model; use World_Model;
with Scheduler;   -- Ensures that the periodic tasks are elaborated before Main runs
procedure Main is

begin
   Init_Static_Map;      -- Draw the NS and EW roads
   Initialized := True;  -- Only after initialization id finished the render task will be elaborated
   null;
end Main;
