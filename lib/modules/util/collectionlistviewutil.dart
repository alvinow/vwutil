import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:vwform/modules/vwcollectionlistviewdefinition/vwcollectionlistviewdefinition.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwutil/modules/util/nodeutil.dart';

class CollectionListViewUtil{

  static VwFormDefinition ? getFormDefinition(VwCollectionListViewDefinition collectionListViewDefinition){

    VwFormDefinition? returnValue;

    try
        {

          if(collectionListViewDefinition!.detailLinkFormDefinition!=null) {
            VwNode? formDefinitionNode= NodeUtil.extractNodeFromLinkNode(
                collectionListViewDefinition!.detailLinkFormDefinition!);



            returnValue=NodeUtil.extractFormDefinitionFromContent(nodeContent: formDefinitionNode!.content);



          }

        }
        catch(error){

        }
        return returnValue;
  }


}