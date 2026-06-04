--  generic_cyclic_task.ads
--  Package: Generic_Cyclic_Task
--  Purpose: Generic abstraction for creating periodic real-time tasks.
--           The instantiator provides:
--             * Job     - the procedure to execute periodically
--             * Period  - the activation interval
--           The package then exposes a task that runs Job at the
--           specified real-time period using delay-until scheduling.
--  Author : Ovi
with Ada.Real_Time;

generic
   --  The procedure to be executed periodically.
   with procedure Job;

      --  The fixed period between activations of Job.
      Period : Ada.Real_Time.Time_Span;

package Generic_Cyclic_Task is
   --  Periodic task executing the user-supplied Job at the given period.
   task Cyclic;

end Generic_Cyclic_Task;
