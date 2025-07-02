import { Controller } from "@hotwired/stimulus"
import DataTable from 'datatables.net-dt';
import "datatables.net-select-dt";

export default class extends Controller {
  connect() {
    new DataTable(this.element)
  }
}
