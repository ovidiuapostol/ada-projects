-------------------------------------------------------------------------
--  renderer.adb
--  Package: Renderer
--  Purpose: Text-based visualization of the traffic-light controller.
--           Uses ANSI escape sequences to clear the screen and display
--           the current NS/EW signal colors in a simple ASCII layout.
--  Author : Ovi
--------------------------------------------------------------------------
with Ada.Text_IO;
with World_Model; use World_Model;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body Renderer is

   --  ANSI escape sequences for colored text output.
   --  These codes wrap the color name so the terminal displays it
   --  in the appropriate color.
   Red_Color         : constant String := ASCII.ESC & "[31m";
   Yellow_Color      : constant String := ASCII.ESC & "[33m";
   Green_Color       : constant String := ASCII.ESC & "[32m";
   Light_Blue_Color  : constant String := ASCII.ESC & "[94m";  --  not used currently
   Bright_Cyan_Color : constant String := ASCII.ESC & "[96m";
   Reset_Color       : constant String := ASCII.ESC & "[0m";

   --------------------------------------------------------------------------
   --  Render_Cell
   --
   --  Convert a sigle world.array character into its collored string
   --  representation. Pedestrians and trafic-light characters are rendered
   --  using ANSI colors. All others characters remains unchanged
   --------------------------------------------------------------------------
   function Render_Cell (C : Character) return String is
   begin
      if C = 'P' then
         return Bright_Cyan_Color & "P" & Reset_Color;
      end if;

      case C is
         when 'R' => return Red_Color & "R" & Reset_Color;
         when 'Y' => return Yellow_Color & "Y" & Reset_Color;
         when 'G' => return Green_Color & "G" & Reset_Color;
         when others =>
            return String'(1 => C);
      end case;
   end Render_Cell;

   ---------------------------------------------------------------------------
   --  Build_Frame
   --
   --  Construct a complete ASCII frame of the current world state.
   --  The world array is read row-by-row, each cell is converted to its
   --  colored representation, and the result is accumulated into a single
   --  string. No screen output occurs here.
   --
   --  This function is pure rendering logic: it reads world state but does
   --  not modify it.
   ---------------------------------------------------------------------------
   function Build_Frame return String is
      Buffer : Unbounded_String :=
        To_Unbounded_String
          ("Traffic Light Simulation" & ASCII.LF &
           "------------------------" & ASCII.LF);
   begin
      for R in Row_Index loop
         for C in Col_Index loop
            Buffer := Buffer & Render_Cell (World (R, C));
         end loop;
         Buffer := Buffer & ASCII.LF;
      end loop;
   return To_String (Buffer);
   end Build_Frame;

   ---------------------------------------------------------------------------
   --  Render_World
   --
   --  Output the current world frame at the terminal's current cursor
   --  position. This procedure does *not* clear the screen or reposition
   --  the cursor; it simply prints the frame produced by Build_Frame.
   --
   --  Used internally by Render, which performs full-screen clearing before
   --  calling this procedure. Render_World is useful when the caller wants
   --  to draw the frame without modifying the terminal state.
   ---------------------------------------------------------------------------
   procedure Render_World is
      Frame : constant String := Build_Frame;
   begin
      if World_Model.Initialized then
         Ada.Text_IO.Put (ASCII.ESC & "H" & Frame);
      end if;

   end Render_World;

   ---------------------------------------------------------------------------
   --  Render
   --
   --  Clear the terminal screen and render the current world frame.
   --  This is the main entry point used by the cyclic rendering task.
   --
   --  Steps:
   --     1. Clear screen and move cursor to home position.
   --     2. Build and output the full frame.
   --
   --  Rendering occurs only if the world has been initialized.
   ---------------------------------------------------------------------------
   procedure Render is
   begin
      if World_Model.Initialized then
         Ada.Text_IO.Put (ASCII.ESC & "[2J" & ASCII.ESC & "[H"); -- clear screen
         Render_World;
      end if;
   end Render;
end Renderer;
