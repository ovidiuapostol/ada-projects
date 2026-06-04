--  renderer.ads
--  Package: Renderer
--  Purpose: Provides text-based visualization utilities for the
--           traffic-light controller. Converts logical colors into
--           colored terminal strings and renders an ASCII diagram
--           showing the current NS/EW signal states.
--  Author : Ovi

with Intersection; use Intersection;
package Renderer is

   --  Convert a logical Color value into a colored string suitable
   --  for terminal output.
   function Color_To_String (C : Color) return String;

   --  Render the current state of the intersection as an ASCII diagram.
   --  Uses ANSI escape sequences for colored output.
   procedure Render;

end Renderer;
