import { LightningElement, api, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getRecordTypeNameById from '@salesforce/apex/Service_AutoResponseFormController.getRecordTypeNameById';
import getAutoResponseFormDisplayByFloor from '@salesforce/apex/Service_AutoResponseFormController.getAutoResponseFormDisplayByFloor';
import updateCase from '@salesforce/apex/Service_AutoResponseFormController.updateCase';
import RECORDTYPEID_FIELD from '@salesforce/schema/Case.RecordTypeId';
import FORMCOMPLETED_FIELD from '@salesforce/schema/Case.FormCompleted__c';
import CASENUMBER_FIELD from '@salesforce/schema/Case.CaseNumber';
import DESCRIPTION_FIELD from '@salesforce/schema/Case.Description';
import formAlreadySent from '@salesforce/label/c.Service_FormAlreadySent';
import noRequestForThisUrl from '@salesforce/label/c.Service_NoRequestForThisUrl';
import requiredFields from '@salesforce/label/c.Service_RequiredFields';
import submit from '@salesforce/label/c.Service_Submit';
import errorContactCustomerServiceByPhone from '@salesforce/label/c.Service_ErrorContactCustomerServiceByPhone';
import formSuccessMessage from '@salesforce/label/c.Service_FormSuccessMessage';
import requestTransmission from '@salesforce/label/c.Service_RequestTransmission';
import keepFileNumber from '@salesforce/label/c.Service_KeepFileNumber';
const fields = [RECORDTYPEID_FIELD, FORMCOMPLETED_FIELD, CASENUMBER_FIELD, DESCRIPTION_FIELD];

export default class service_AutoResponseForm extends LightningElement {

    @api recordId; // The case ID is passed through a URL param.
    @track isLoaded = false; // Set the waiting spinner display on client-server trips.
    recordTypeId; // The record type conditions the whole form display.
    @track caseNumber;
    description; // The description input is prefilled with the case description.
    floor; // The floor is the record type developer name.
    formCompleted = false; // The form can only be fulfilled once. A message tells if it has already been.
    hideForm = false; // Hides the form when it has already been fulfilled once.
    @track visibleFields;
    requiredFields;
    @track error;
    label = {
        formAlreadySent, noRequestForThisUrl, requiredFields, submit,
        formSuccessMessage, requestTransmission, keepFileNumber, errorContactCustomerServiceByPhone
    };

    @wire(getRecord, { recordId: '$recordId', fields })
    loadCase({ error, data }) {
        if (error) {
            this.error = this.label.noRequestForThisUrl;
            this.recordTypeId = undefined;
            this.formCompleted = undefined;
            this.displayErrorFrame();
            this.isLoaded = true;
        }
        else if (data) {
            this.error = undefined;
            if (data.fields.FormCompleted__c.value) {
                this.formCompleted = true;
                this.hideForm = true;
            }
            else {
                this.recordTypeId = data.fields.RecordTypeId.value;
                this.caseNumber = data.fields.CaseNumber.value;
                this.description = data.fields.Description.value;
            }
        }
    }

    @wire(getRecordTypeNameById, { recordTypeId: '$recordTypeId' })
    setFloor({ error, data }) {
        if (error) {
            this.error = this.label.errorContactCustomerServiceByPhone;
            this.floor = undefined;
            this.displayErrorFrame();
            this.isLoaded = true;
        }
        else if (data) {
            this.error = undefined;
            this.floor = data;
            this.template.querySelector('.error-frame').classList.add('slds-hide');
            this.template.querySelector('lightning-record-edit-form').classList.remove('slds-hide');
            this.template.querySelector('.form-bottom').classList.remove('slds-hide');
        }
    }

    @wire(getAutoResponseFormDisplayByFloor, { floor: '$floor' })
    setFields({ error, data }) {
        if (error) {
            this.error = this.label.errorContactCustomerServiceByPhone;
            this.visibleFields = undefined;
            this.requiredFields = undefined;
            this.displayErrorFrame();
            this.isLoaded = true;
        }
        else if (data) {
            this.error = undefined;
            this.template.querySelector('.error-frame').classList.add('slds-hide');
            this.template.querySelector('lightning-record-edit-form').classList.remove('slds-hide');
            this.template.querySelector('.form-bottom').classList.remove('slds-hide');
            if (data.VisibleFields__c) {
                this.visibleFields = data.VisibleFields__c.replace(/\s/g, '').split(';');
                this.template.querySelector('.form-bottom').classList.remove('slds-hide');
            }
            if (data.RequiredFields__c) {
                this.requiredFields = data.RequiredFields__c.replace(/\s/g, '').split(';');
            }
        }
    }

    handleLoad() {
        var temp = this.template;
        if (this.formCompleted) {
            this.error = this.label.formAlreadySent;
            this.displayErrorFrame();
        }
        else if (!this.recordId || !this.recordTypeId) {
            this.error = this.label.noRequestForThisUrl;
            this.displayErrorFrame();
        }
        else if (this.hideForm) {
            temp.querySelector('lightning-record-edit-form').classList.add('slds-hide');
        }
        if (this.requiredFields) {
            this.requiredFields.forEach(function (requiredField) {
                var selector = 'lightning-input-field[data-item=\'' + requiredField + '\']';
                temp.querySelector(selector).required = true;
            });
        }
        this.isLoaded = true;
    }

    renderedCallback() {
        var descriptionInput = this.template.querySelector('lightning-input-field[data-item=\'Description\']');
        if (this.description && descriptionInput) {
            descriptionInput.value = this.description;
        }
    }

    displayErrorFrame() {
        this.template.querySelector('.error-frame').classList.remove('slds-hide');
        this.template.querySelector('lightning-record-edit-form').classList.add('slds-hide');
        this.template.querySelector('.form-bottom').classList.add('slds-hide');
    }

    handleClickOnSubmit() {
        this.template.querySelector('.error-frame').classList.add('slds-hide');
    }

    handleSubmit(event) {
        const formFields = event.detail.fields;
        event.preventDefault();
        this.isLoaded = false;
        this.handleUpdate(formFields);
    }

    handleUpdate(formFields) {
        updateCase({ caseId: this.recordId, fields: formFields })
            .then(result => {
                this.error = undefined;
                if (result === 'Success') {
                    this.template.querySelector('.error-frame').classList.add('slds-hide');
                    this.template.querySelector('.success-frame').classList.remove('slds-hide');
                    this.template.querySelector('lightning-record-edit-form').classList.add('slds-hide');
                }
                else {
                    // When a max-length error occurs on an input, translate the message from English to French.
                    if (result.includes('max length=')) {
                        result = result.replace('max length=', 'nombre maximum de caractères=')
                    }
                    this.error = result;
                    this.template.querySelector('.error-frame').classList.remove('slds-hide');
                }
                this.isLoaded = true;
            })
            .catch(error => {
                this.error = error;
                this.isLoaded = true;
            });
    }

}