class SelectionState {
  int quantity;
  int size;
  SelectionState(this.quantity, this.size);

  void setSize (int x) {
    size = x;
  }

  void setQuantity (int x) {
    quantity = x;
  }
}