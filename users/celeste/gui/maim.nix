{ pkgs, ... }: {
  home.packages = with pkgs; [ maim slop ];
  xdg.configFile = {
    # These are from https://github.com/naelstrof/slop/tree/master/shaderexamples
    # `maim --help` claims these are loaded from maim, but on runtime the error shows it's looking in slop, so, uh
    "slop/boxzoom.vert".text = ''
      #version 120

      attribute vec2 position;
      attribute vec2 uv;

      varying vec2 uvCoord;

      void main()
      {
        uvCoord = uv;
        gl_Position = vec4(position,0,1);
      }
    '';
    "slop/boxzoom.frag".text = ''
      #version 120

      uniform sampler2D texture;
      uniform sampler2D desktop;
      uniform vec2 screenSize;
      uniform vec2 mouse;

      varying vec2 uvCoord;

      void main()
      {
          // Adjustable parameters -------
          vec2 boxOffset = vec2(-64,-64);
          vec2 boxSize = vec2(128,128);
          float magstrength = 4;
          vec2 borderSize = vec2(1,1);
          vec4 borderColor = vec4(0,0,0,1);
          bool crosshair = true;
          //------------------------------

          // actual code (don't touch unless you're brave)

          // convert to UV space
          boxOffset = boxOffset/screenSize;
          boxSize = boxSize/screenSize;
          borderSize = borderSize/screenSize;
          // get mouse position in UV space
          vec2 mpos = vec2(mouse.x, -mouse.y)/screenSize + vec2(0,1);
          vec4 color;

          // Check if our current UV is inside our box.
          if ( uvCoord.x < mpos.x+boxOffset.x+boxSize.x &&
              uvCoord.x > mpos.x+boxOffset.x &&
              uvCoord.y > mpos.y+boxOffset.y &&
              uvCoord.y < mpos.y+boxOffset.y+boxSize.y ) {
            // Check if we're actually inside the crosshair area.
            if ( (distance(uvCoord.x, mpos.x+boxOffset.x+boxSize.x/2) <= borderSize.x ||
                  distance(uvCoord.y, mpos.y+boxOffset.y+boxSize.y/2) <= borderSize.y) && crosshair ) {
              color = borderColor;
            } else {
              // Calculate where the UV should be.
              vec2 zoomedUV = ((uvCoord-mpos)-(boxOffset+boxSize/2))/magstrength+mpos;
              // The desktop texture is upside-down due to X11
              vec2 zoomedUVFlipped = vec2( zoomedUV.x, -zoomedUV.y );
              // Then change the color to the desktop color to draw, then add on our rectangle on top.
              vec4 rectColor = texture2D( texture, zoomedUV );
              color = mix( texture2D( desktop, zoomedUVFlipped ), rectColor, rectColor.a );
            }
          // Then check if we're in our border size.
          } else if( uvCoord.x <= mpos.x+boxOffset.x+boxSize.x+borderSize.x &&
              uvCoord.x >= mpos.x+boxOffset.x-borderSize.x &&
              uvCoord.y >= mpos.y+boxOffset.y-borderSize.y &&
              uvCoord.y <= mpos.y+boxOffset.y+boxSize.y+borderSize.y ) {
            color = borderColor;
          } else {
            color = texture2D( texture, uvCoord );
          }

          gl_FragColor = color;
      }
    '';
    "slop/crosshair.vert".text = ''
      #version 120

      attribute vec2 position;
      attribute vec2 uv;

      varying vec2 uvCoord;

      void main()
      {
      	uvCoord = uv;
      	gl_Position = vec4(position,0,1);
      }
    '';
    "slop/crosshair.frag".text = ''
      #version 120

      uniform sampler2D texture;
      uniform sampler2D desktop;
      uniform vec2 screenSize;
      uniform vec2 mouse;

      varying vec2 uvCoord;

      void main()
      {
          // adjustable parameters
          float circleSize = 64;
          float borderSize = 2;
          // The smaller this value is, the more intense the magnification!
          float magnifyNerf = 1.1;
          vec4 borderColor = vec4(0,0,0,1);
          bool crosshair = true;

          // actual code
          vec2 mUV = vec2(mouse.x, -mouse.y)/screenSize + vec2(0,1);
          float du = distance(mUV,uvCoord);
          float dr = distance(mUV*screenSize,uvCoord*screenSize);
          vec4 color = vec4(0);
          if ( dr > circleSize+borderSize ) {
              color = texture2D( texture, uvCoord );
          } else if ( dr < circleSize ) {
              if ( crosshair && (distance(mUV.x, uvCoord.x)<1/screenSize.x || distance(mUV.y,uvCoord.y)<1/screenSize.y) ) {
                  color = borderColor;
              } else {
                  float t = 1-du;
                  vec2 b = uvCoord;
                  vec2 c = (mUV-uvCoord);
                  vec2 upsideDown = c/magnifyNerf*t*t+b;

                  vec4 textureColor = texture2D( texture, upsideDown );
                  color = mix( texture2D( desktop, vec2(upsideDown.x, -upsideDown.y) ), textureColor, textureColor.a );
              }
          } else if ( dr < circleSize+borderSize ) {
              color = borderColor;
          }
          gl_FragColor = color;
      }
    '';
  };
}
