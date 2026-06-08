--------------------------------------------------------------------------
--  renderer.ads
--  Package: Renderer
--  Purpose: Provides text-based visualization utilities for the
--           traffic-light controller. Converts logical colors into
--           colored terminal strings and renders an ASCII diagram
--           showing the current NS/EW signal states.
--  Author : Ovi
--------------------------------------------------------------------------
package Renderer is

   --  Render the current state of the intersection as an ASCII diagram.
   --  Uses ANSI escape sequences for colored output.
   procedure Render;

end Renderer;
