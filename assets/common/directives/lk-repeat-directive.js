angular.module('app').directive('lkRepeat', function(){
  return {
    transclude : 'element',    
    scope: false,
    compile : function(element, attr, linker){
      return function($scope, $element, $attr){
        
        var myLoop = $attr.lkRepeat,
            match = myLoop.match(/^\s*(.+)\s+in\s+(.*?)\s*(\s+track\s+by\s+(.+)\s*)?$/),
            indexString = match[1],
            collectionString = match[2],
            parent = $element.parent(),
            elements = [];
        
        /*console.log('myLoop', myLoop);
        console.log('indexString', indexString);
        console.log('collectionString', collectionString);
        console.log('collection', $scope.names);
        console.log('parent', parent);
        console.log('elements', elements);*/

        // $watchCollection is called everytime the collection is modified
        $scope.$watchCollection(collectionString, function(collection){
          
          var i, block, childScope;

          // check if elements have already been rendered
          if(elements.length > 0) {
            // if so remove them from DOM, and destroy their scope
            for (i = 0; i < elements.length; i++) {
              elements[i].el.remove();
              elements[i].scope.$destroy();
            };
            elements = [];
          }

          for (i = 0; i < collection.length; i++) {
            // create a new scope for every element in the collection.
            childScope = $scope.$new();
            
            // pass the current element of the collection into that scope
            childScope[indexString] = collection[i];

            linker(childScope, function(clone){
              
              // clone the transcluded element, passing in the new scope.
              parent.append(clone); // add to DOM
              block = {};
              block.el = clone;
              block.scope = childScope;
              elements.push(block);
            });
          };
        });
      }
    }
  }
});
