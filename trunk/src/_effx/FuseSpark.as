package _effx
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.geom.Point;
   
   import org.flintparticles.common.actions.Age;
   import org.flintparticles.common.actions.Fade;
   import org.flintparticles.common.counters.Random;
   import org.flintparticles.common.counters.TimePeriod;
   import org.flintparticles.common.counters.ZeroCounter;
   import org.flintparticles.common.displayObjects.Line;
   import org.flintparticles.common.easing.Cubic;
   import org.flintparticles.common.emitters.Emitter;
   import org.flintparticles.common.initializers.ColorInit;
   import org.flintparticles.common.initializers.ImageClasses;
   import org.flintparticles.common.initializers.Lifetime;
   import org.flintparticles.twoD.actions.Accelerate;
   import org.flintparticles.twoD.actions.Move;
   import org.flintparticles.twoD.actions.RotateToDirection;
   import org.flintparticles.twoD.emitters.Emitter2D;
   import org.flintparticles.twoD.initializers.Position;
   import org.flintparticles.twoD.initializers.Velocity;
   import org.flintparticles.twoD.renderers.DisplayObjectRenderer;
   import org.flintparticles.twoD.zones.DiscSectorZone;
   import org.flintparticles.twoD.zones.PointZone;
   
   /**
   * A fuse-spark effect basing on FLiNT particle system.
    * @author boy, cjboy1984@gmail.com
    * @usage
    * FuseSpark.init(stage);
    * // x:100, y:200, minAngle:-90, maxAngle:90
    * FuseSpark.addPulse(100, 200, -90, 90);
    * // or
    * FuseSpark.start(100, 200);
    * FuseSpark.stop();
    */
   public class FuseSpark
   {
      public static const DEF_MIN_ANGLE:Number = -125;
      public static const DEF_MAX_ANGLE:Number = -55;
      
      protected var renderer:DisplayObjectRenderer;
      protected var emitter:Emitter2D;
      // velocity
      protected var vec:Velocity;
      
      /**
       * The parent of the renderer.
       */
      protected function get parent():DisplayObjectContainer { return DisplayObjectContainer(renderer.parent); }
      
      // singleton
      private static var _instance:FuseSpark;
      
      public function FuseSpark(pvt:PrivateClass)
      {
         renderer = new DisplayObjectRenderer();
         renderer.addEventListener(Event.ADDED_TO_STAGE, onAdd);
         renderer.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
         
         // velocity
         vec = new Velocity(new DiscSectorZone(new Point(), 120, 30, toRadian(DEF_MIN_ANGLE), toRadian(DEF_MAX_ANGLE)));
         
         emitter = new Emitter2D();
         emitter.addInitializer(new ImageClasses([Line1,Line2,Line3]));
         emitter.addInitializer(new ColorInit(0xffffcc00,0xfff9f7bf));
         emitter.addInitializer(vec);
         emitter.addInitializer(new Lifetime(0.3, 1.25));
         emitter.addInitializer(new Position(new PointZone(new Point())));
         
         emitter.addAction(new Age(Cubic.easeIn));
         emitter.addAction(new Accelerate(0, 300));
         emitter.addAction(new Move());
         emitter.addAction(new Fade());
         emitter.addAction(new RotateToDirection());
         
         renderer.addEmitter(emitter);
      }
      
      // --------------------- LINE ---------------------
      
      /**
       * Initialize this effect
       * @param $container          mostly is stage.
       * @usage
       * FuseSpark.init(stage);
       */
      public static function init($container:DisplayObjectContainer):void
      {
         $container.addChild(api.renderer);
      }
      
      /**
       * Add a pulse effect.
       * @param $x                  x location.
       * @param $y                  y location.
       * @param $minAngle           The minimum angle, in radians.
       * @param $maxAngle           The maximum angle, in radians.
       * @param $bringToTop         Whether to bring the renderer to the toppest layer.
       * @param $newCoordinateRef   The new container you want to switch.
       */
      public static function addPulse($x:Number = 0, $y:Number = 0, $minAngle:Number = DEF_MIN_ANGLE, $maxAngle:Number = DEF_MAX_ANGLE, $bringToTop:Boolean = false, $newCoordinateRef:DisplayObjectContainer = null):void
      {
         if (!api.parent) return;
         setInfo($x, $y, $minAngle, $maxAngle, $bringToTop, $newCoordinateRef);
         
         api.emitter.counter = new TimePeriod(30, 0.1);
         api.emitter.start();
      }
      
      /**
       * Add a continues effect. And you can call FuseSpark.stop() to stop creating the particle
       * @param $x                  x location.
       * @param $y                  y location.
       * @param $minAngle           The minimum angle, in radians.
       * @param $maxAngle           The maximum angle, in radians.
       * @param $bringToTop         Whether to bring the renderer to the toppest layer.
       * @param $newCoordinateRef   The new container you want to switch.
       */
      public static function start($x:Number = 0, $y:Number = 0, $minAngle:Number = 0, $maxAngle:Number = 0, $bringToTop:Boolean = false, $newCoordinateRef:DisplayObjectContainer = null):void
      {
         if (!api.parent) return;
         setInfo($x, $y, $minAngle, $maxAngle, $bringToTop, $newCoordinateRef);
         
         api.emitter.counter = new Random(60, 100);
         api.emitter.start();
      }
      
      public static function stop():void
      {
         api.emitter.counter = new ZeroCounter();
      }
      
      // --------------------- LINE ---------------------
      
      public static function setChildIndex($z:int = 0):void
      {
         if (!api.renderer.parent) return;
         
         var _z = $z;
         if (_z > api.renderer.parent.numChildren-1)
         {
            _z = api.renderer.parent.numChildren - 1;
         }
         api.renderer.parent.setChildIndex(api.renderer, _z);
      }
      
      public static function get container():DisplayObjectContainer { return DisplayObjectContainer(api.renderer.parent); }
      
      // ################### protected ##################
      
      protected function onAdd(e:Event):void
      {
      }
      
      protected function onRemove(e:Event):void
      {
         for each (var i:Emitter in renderer.emitters) 
         {
            i.stop();
         }
      }
      
      // --------------------- LINE ---------------------
      
      protected static function get api():FuseSpark
      {
         if (!_instance)
         {
            _instance = new FuseSpark(new PrivateClass());
         }
         
         return _instance;
      }
      
      // --------------------- LINE ---------------------
      
      protected static function setInfo($x:Number, $y:Number, $minAngle:Number, $maxAngle:Number, $bringToTop:Boolean, $newCoordinateRef:DisplayObjectContainer):void
      {
         // bring renderer to toppest layer
         if ($bringToTop)
         {
            api.parent.setChildIndex(api.renderer, api.parent.numChildren-1);
         }
         
         var newX:Number = $x;
         var newY:Number = $y;
         
         // If a new coordinate system is assigned.
         if ($newCoordinateRef)
         {
            var localPos:Point = $newCoordinateRef.globalToLocal(new Point($x, $y));
            newX = localPos.x;
            newY = localPos.y;
         }
         
         // position
         api.emitter.x = newX;
         api.emitter.y = newY;
         
         // rotation
         api.vec.zone = new DiscSectorZone(new Point(), 90, 30, toRadian($minAngle), toRadian($maxAngle));
      }
      
      protected static function toRadian(degree:Number):Number
      {
         return degree * Math.PI / 180;
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}

// #################### private ###################

import org.flintparticles.common.displayObjects.Line;

class Line1 extends Line
{
   public function Line1()
   {
      super(1);
   }
}

class Line2 extends Line
{
   public function Line2()
   {
      super(2);
   }
}

class Line3 extends Line
{
   public function Line3()
   {
      super(3);
   }
}

// --------------------- LINE ---------------------

class PrivateClass
{
   function PrivateClass() {}
}

// --------------------- LINE ---------------------