package casts
{
   import casts.impls.ICastObject;
   
   import flash.utils.Dictionary;

   /**
    * @author boy, cjboy1984@gmail.com
    * @usage
    * 1. Implement your class with ICastObject!
    * 
    * // Add to pool on Event.ADDED_TO_STAGE handler.
    * CastPool.add(this);
    * // Then you can easily get the reference
    * CastPool.getCastById('aaa');
    * // Or want to get the whole references with the same group
    * CastPool.getCastsByGroup('aaa_group');
    * 
    * // Remove from pool on Event.REMOVED_FROM_STAGE.
    * CastPool.remove(this);
    */
   public class CastPool
   {
      private static var instance:CastPool;
      // pool
      private var pool:Dictionary;

      public function CastPool(pvt:PrivateClass) {}

      // --------------------- LINE ---------------------
      
      // Save into the pool.
      public static function add($cast:ICastObject):void
      {
         var pool:Dictionary = getInstance().pool;
         if (pool.hasOwnProperty($cast.id))
         {
            var msg:String = "CastPool.add() | Have exactly the same id in the pool\n";
            msg += ($cast + ".id = " + $cast.id + "\n");
            msg += "The new one will replace the old one and the old one won\'t be refer anymore.";
            throw new Error(msg);
            
            // delete old one
            delete pool[$cast.id];
         }
         
         // save new one
         getInstance().pool[$cast.id] = $cast;
      }
      
      // Remove from the pool.
      public static function remove($cast:ICastObject):void
      {
         var pool:Dictionary = getInstance().pool;
         if (pool.hasOwnProperty($cast.id))
         {
            delete pool[$cast.id];
         }
      }
      
      // --------------------- LINE ---------------------
      
      // Get the reference of the instance by given id.
      public static function getCastById($id:String):Object
      {
         var pool:Dictionary = getInstance().pool;
         if (pool.hasOwnProperty($id))
         {
            return pool[$id];
         }
         
         return null;
      }
      
      // Get a array that stores all the instances with the same group.
      public static function getCastsByGroup($group:String):Array
      {
         // TODO
         return null;
      }

      // ################### protected ##################
      
      protected static function getInstance():CastPool
      {
         if (!instance)
         {
            instance = new CastPool(new PrivateClass());
            instance.pool = new Dictionary();
         }
         
         return instance;
      }

      // #################### private ###################

      // --------------------- LINE ---------------------

   }

}

class PrivateClass
{
   function PrivateClass() {}
}
