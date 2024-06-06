// leadSearchComponent.js
import { LightningElement, wire,api } from 'lwc';
import getSpecializations from '@salesforce/apex/LeadSearchController.getSpecializations';
import searchLeads from '@salesforce/apex/LeadSearchController.searchLeads';
import setLeadInJuction from '@salesforce/apex/LeadSearchController.setLeadsInJunctionObject';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const columns=[

    {label:'Name',fieldName:'Name',editable:false},
    {label:'Region',fieldName:'Country',editable:false},
    {label:'Specialization',fieldName:'Specialization__c',editable:false},
    
    ];
export default class LeadSearchComponent extends LightningElement {
    @api recordId;
    columns = columns;
    selectedSpecialization = '';
    region = '';
    leads = [];
    specializationOptions = [];
    selectedRows = [];
    
    //specializationOptions Fetch specialization options from Apex controller
    @wire(getSpecializations,{})
    getSpecializationOption({ error, data }) {
        if (data) {
            let options = [];
            
            for(var key in data) {
                
                options.push({ label: data[key], value: data[key] });
                }
                this.specializationOptions=options;
                
        } else if (error) {
            console.error(error);
        }
    }
   
    

    handleSpecializationChange(event) {
        this.selectedSpecialization = event.detail.value;
    }

    handleRegionChange(event) {
        this.region = event.detail.value;
    }

    handleSearch() {
        searchLeads({ specialization: this.selectedSpecialization, region: this.region })
            .then(result => {
                this.leads = result;
            })
            .catch(error => {
                console.error('Error fetching leads:', error);
            });
    }

    handleRowSelection(event) {
        this.selectedRows = event.detail.selectedRows;
        
    }
    
    handleSave() {
       
       if(this.selectedRows.length>0){
        var selecteLeadIds=[];

       for (const key in this.selectedRows) {
        selecteLeadIds.push(this.selectedRows[key].Id);
        console.log(this.selectedRows[key].Id);
       }
       console.log('selecteLeadIds=======>'+selecteLeadIds);
       console.log('record id:>>>>', this.recordId)
      setLeadInJuction({leadIds: selecteLeadIds , productId: this.recordId})
      .then(result => {
        const event = new ShowToastEvent({
            title: result,
            variant: 'success'
        });
        this.dispatchEvent(event);
       }).catch(error => {
        const event = new ShowToastEvent({
            title: error,
            variant: 'error'
        });
        this.dispatchEvent(event);
       })
    }else{
        const event = new ShowToastEvent({
            title: 'Please select Lead.',
            variant: 'warning'
        });
        this.dispatchEvent(event);
    }
    }
}