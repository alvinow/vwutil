import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/util/nodeutil.dart';
import 'package:matrixclient/modules/vwcollectionlistviewdefinition/vwcollectionlistviewdefinition.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwfielduiparam/vwfielduiparam.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformdefinition.dart';

class CollectionListViewUtil{

  static VwFormDefinition? getFormDefinition(VwCollectionListViewDefinition collectionListViewDefinition){

    VwFormDefinition? returnValue;

    try
        {

          if(collectionListViewDefinition!.detailLinkFormDefinition!=null) {
            VwNode? formDefinitionNode= NodeUtil.extractNodeFromLinkNode(
                collectionListViewDefinition!.detailLinkFormDefinition!);



            returnValue=NodeUtil.extractFormDefinitionFromContent(nodeContent: formDefinitionNode!.content);


            /*
            returnValue = VwFormDefinition.fromJson(
                collectionListViewDefinition!.detailLinkFormDefinition!
                    .rendered!.node!.content!.classEncodedJson!.data!);*/
          }
          /*


          if(collectionListViewDefinition.detailFormDefinitionMode== VwFieldUiParam.dfmLinkFormDefinition)
            {
              returnValue=collectionListViewDefinition.detailLinkFormDefinition!.renderedFormDefinition;
            }
          else if(collectionListViewDefinition.detailFormDefinitionMode==VwFieldUiParam.dfmLocal)
            {
              returnValue=collectionListViewDefinition.detailFormDefinition;
            }
*/
        }
        catch(error){

        }
        return returnValue;
  }


}