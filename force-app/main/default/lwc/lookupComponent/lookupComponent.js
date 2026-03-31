import { LightningElement, api, track } from 'lwc';
import searchAccounts from '@salesforce/apex/AccountLookupController.search';
import searchAll from '@salesforce/apex/MultiObjectLookupController.searchAll';

const SEARCH_DELAY = 300; // milliseconds

export default class LookupComponent extends LightningElement {

    // ─── Public Properties ─────────────────────────────────────────────
    @api label       = 'Search';
    @api placeholder = 'Search...';
    @api searchType  = 'account'; // 'account' or 'all'

    // ─── Private Properties ────────────────────────────────────────────
    @track results      = [];
    @track isOpen       = false;
    @track isLoading    = false;
    @track searchTerm   = '';
    @track selectedItem = null;

    _searchTimeout;
    _selectedIds = [];

    // ─── Computed Properties ───────────────────────────────────────────
    get comboboxClass() {
        return 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click' +
               (this.isOpen ? ' slds-is-open' : '');
    }

    get noResults() {
        return !this.isLoading &&
                this.results.length === 0 &&
                this.searchTerm.length > 0;
    }

    // ─── Event Handlers ────────────────────────────────────────────────
    handleInput(event) {
        this.searchTerm = event.target.value;

        // Clear previous timer
        clearTimeout(this._searchTimeout);

        if (this.searchTerm.length === 0) {
            this.results  = [];
            this.isOpen   = false;
            return;
        }

        // Debounce — wait 300ms before searching
        this._searchTimeout = setTimeout(() => {
            this.performSearch();
        }, SEARCH_DELAY);
    }

    handleFocus() {
        if (this.searchTerm.length > 0) {
            this.isOpen = true;
        }
    }

    handleBlur() {
        this.isOpen = false;
    }

    handleSelect(event) {
        const id    = event.currentTarget.dataset.id;
        const title = event.currentTarget.dataset.title;
        const icon  = this.results.find(r => r.id === id)?.icon || 'standard:record';

        this.selectedItem = { id, title, icon };
        this._selectedIds = [id];
        this.searchTerm   = '';
        this.results      = [];
        this.isOpen       = false;

        // Fire event to parent component
        this.dispatchEvent(new CustomEvent('select', {
            detail: { id, title }
        }));
    }

    handleRemove() {
        this.selectedItem = null;
        this._selectedIds = [];

        // Fire event to parent component
        this.dispatchEvent(new CustomEvent('remove'));
    }

    // ─── Search Logic ──────────────────────────────────────────────────
    performSearch() {
        this.isLoading = true;
        this.isOpen    = true;

        const searchFn = this.searchType === 'all' ? searchAll : searchAccounts;

        searchFn({
            searchTerm  : this.searchTerm,
            selectedIds : this._selectedIds
        })
        .then(data => {
            this.results   = data;
            this.isLoading = false;
        })
        .catch(error => {
            console.error('Lookup search error:', error);
            this.isLoading = false;
        });
    }
}