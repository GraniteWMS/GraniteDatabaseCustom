# PickMethod

- Script Name: PreScriptPickingPickMethod

The Pickmethod step is a step at the start of picking that allows the selection of how to get the picking document.
The methods are:

'ENTERDOC'  - Clear any selection list in ProcessStepDynamic so that the User enters or scans the Document
'NEXTDOC'  -Select the Next Document in the available picking documents
'SELECTDOC'  -Populate the ProcessStepLookup with a list of Released documents to select from.  Exclude Documents that are busy being picked (Transaction in last 15minutes)
'ASSIGNEDDOC' -Populate the ProcessStepLookupDynamic with a list of Released documents allocated to the User.