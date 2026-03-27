import * as wjCore from '@grapecity/wijmo';
import { DropDown } from '@grapecity/wijmo.input';
import { TreeView } from '@grapecity/wijmo.nav';
import { NgModule } from '@angular/core';
export class TreeViewEditor extends DropDown {
  public checkedItems: any[];
  public itemsSource: any[];
  public showDropDownButton: boolean;
  public minLength: number = 3;
  public treeView: any;

  constructor(element: any, private options?: any) {
    super(element);
    //
    // Initialize the control with the given properties.
    this.treeView.initialize(this.options?.treeViewOptions);
    //
    this.text = this.options?.text;
  }

  _createDropDown() {
    // Hide the dropDown button.
    this.showDropDownButton = false;
    // Create an instance of TreeView.
    this.treeView = new TreeView(this._dropDown);
    // Set the height and width of the dropDown panel.
    wjCore.setCss(this._dropDown, { maxWidth: 180, maxHeight: 350 });
    // Display the dropDown when input got focus.
    this.gotFocus.addHandler((sender, args) => {
      this.isDroppedDown = true;
      this.text.length && (this.text += ',');
    });
    // Display the dropDown when input got focus.
    this.lostFocus.addHandler((sender, args) => {
      this.text = this.text.slice(0, this.text.length);
    });
    // Update the checked state of the nodes.
    this.isDroppedDownChanging.addHandler((sender, args) => {
      // Update the checked state of the nodes based on the entered text.
      this.checkNodes(this.treeView.nodes, null, this.text);
      // Remove the ',' from the end of the text.
      if (sender.isDroppedDown) {
        this.text = this.text.slice(0, this.text.length - 1);
      }
    });
    // Add an handler to search the treeView source when text is changed.
    this.textChanged.addHandler((sender: DropDown, args) => {
      let values = this.text.split(',');
      // If the text that is to be searched next contains equal or more than the minLength characters or not.
      if (values[values.length - 1].trim().length >= this.minLength) {
        this.expandMatchedNodes(
          this.treeView.nodes,
          values[values.length - 1].trim()
        );
      }
    });
    //
    this.treeView.checkedItemsChanged.addHandler((sender, args) => {
      let alreadyEnteredValues = this.text
        .split(',')
        .map((item) => item.trim());
      //
      let lastEnteredValue =
        alreadyEnteredValues[alreadyEnteredValues.length - 1];
      if (!sender.selectedNode) return;
      //
      if (!sender.selectedNode.nodes) {
        if (
          sender.selectedNode &&
          sender.selectedNode.isChecked &&
          lastEnteredValue !== sender.selectedItem.header
        ) {
          alreadyEnteredValues.pop();

          // Add the item to the text.
          this.text =
            alreadyEnteredValues.join(',') +
            ',' +
            sender.selectedItem.header +
            ',';
          // // Add the item to the text.
          // this.text += sender.selectedItem.header + ',';
        }
        // Remove the unselected node from the text.
        else if (sender.selectedNode) {
          let index = alreadyEnteredValues.indexOf(sender.selectedItem.header);
          alreadyEnteredValues.splice(index, 1);
          this.text = alreadyEnteredValues.join(',');
        }
      }
      // Header node is selected. Add/Remove multiple items from the text.
      else if (sender.selectedNode.nodes) {
        let items = this.getItems(sender.selectedNode);
        // Add
        if (sender.selectedNode.isChecked) {
          this.text += items.join(',');
        }
        // Remove
        else {
          this.text =
            alreadyEnteredValues
              .filter((item) => !items.includes(item))
              .join(',') + ',';
        }
      }
    });
  }

  // To update the checked state of the node.
  private checkNodes(nodes, searchList, text) {
    // set defaults
    if (searchList == null) searchList = [];
    // add items and sub-items
    for (let i = 0; i < nodes.length; i++) {
      let node = nodes[i];
      if (text.includes(node.dataItem.header)) node.isChecked = true;
      if (node.nodes) {
        this.checkNodes(node.nodes, searchList, text);
      }
    }
    return searchList;
  }

  // To expand the node that contains the typed text.
  private expandMatchedNodes(nodes, text) {
    for (let i = 0; i < nodes.length; i++) {
      let node = nodes[i];
      if (node.dataItem.header.includes(text)) {
        node.ensureVisible();
      }
      if (node.nodes) {
        this.expandMatchedNodes(node.nodes, text);
      }
    }
    return;
  }

  // To get the items of a parent TreeNode.
  private getItems(node, list = []) {
    let nodes = node.nodes;
    for (let i = 0; i < nodes.length; i++) {
      let node = nodes[i];
      list.push(node.dataItem.header);
      if (node.nodes) {
        this.getItems(node.nodes, list);
      }
    }
    return list;
  }
}
