--  renderer.adb
--  Package: Renderer
--  Purpose: Text-based visualization of the traffic-light controller.
--           Uses ANSI escape sequences to clear the screen and display
--           the current NS/EW signal colors in a simple ASCII layout.
--  Author : Ovi
with Ada.Text_IO;
use Ada.Text_IO;

package body Renderer is

   --  ANSI escape sequences for colored text output.
   --  These codes wrap the color name so the terminal displays it
   --  in the appropriate color.
   Red_Color    : constant String := ASCII.ESC & "[31m";
   Yellow_Color : constant String := ASCII.ESC & "[33m";
   Green_Color  : constant String := ASCII.ESC & "[32m";
   Reset_Color  : constant String := ASCII.ESC & "[0m";

   --  Convert a logical Color value into a colored string suitable
   --  for terminal output.
   function Color_To_String (C : Color) return String is
   begin
      case C is
         when Red    => return Red_Color    & "RED   " & Reset_Color;
         when Yellow => return Yellow_Color & "YELLOW" & Reset_Color;
         when Green  => return Green_Color  & "GREEN " & Reset_Color;
      end case;
   end Color_To_String;

   --  Render the current state of the intersection as an ASCII diagram.
   --  The screen is cleared, then the NS and EW lights are shown using
   --  colored text to represent their current signal values.
   procedure Render is
   begin
      --  Clear screen (ANSI escape)
      Put (ASCII.ESC & "[2J" & ASCII.ESC & "[H");

      Put_Line ("Traffic Light Simulation");
      Put_Line ("------------------------");
      Put_Line ("");

      Put_Line ("            North");
      Put_Line ("              |");
      Put_Line ("              |");
      Put_Line ("          [" & Color_To_String (Intersection_Controller.NS_Color) & "]");
      Put_Line ("              |");
      Put_Line ("              |");
      Put_Line ("              |");
      Put_Line ("West ---------+-----------[" & Color_To_String (Intersection_Controller.EW_Color) & "]--- East");
      Put_Line ("              |");
      Put_Line ("              |");
      Put_Line ("              |");
      Put_Line ("              |");
      Put_Line ("              |");
      Put_Line ("              |");
      Put_Line ("            South");
   end Render;

end Renderer;
