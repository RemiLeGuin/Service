import { LightningElement, api, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import getRecordTypeName from '@salesforce/apex/Service_AutoResponseFormController.getRecordTypeName';
import getMetadata from '@salesforce/apex/Service_AutoResponseFormController.getFormDisplayMetadata';
import getRequiredFieldsExtra from '@salesforce/apex/Service_AutoResponseFormController.getFormRequiredFieldsExtra';
import updateCase from '@salesforce/apex/Service_AutoResponseFormController.updateCase';
import RECORDTYPEID_FIELD from '@salesforce/schema/Case.RecordTypeId';
import FORMCOMPLETED_FIELD from '@salesforce/schema/Case.FormCompleted__c';
import CASENUMBER_FIELD from '@salesforce/schema/Case.CaseNumber';
import DESCRIPTION_FIELD from '@salesforce/schema/Case.Description';
import formAlreadySent from '@salesforce/label/c.Service_FormAlreadySent';
import noRequestForThisUrl from '@salesforce/label/c.Service_NoRequestForThisUrl';
import requiredFields from '@salesforce/label/c.Service_RequiredFields';
import submit from '@salesforce/label/c.Service_Submit';
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
    @track message;
    label = {
        formAlreadySent, noRequestForThisUrl, requiredFields, submit,
        formSuccessMessage, requestTransmission, keepFileNumber
    };

    @wire(getRecord, { recordId: '$recordId', fields })
    loadCase({ error, data }) {
        if (error) {
            this.error = error;
            this.recordTypeId = undefined;
            this.formCompleted = undefined;
        }
        else if (data) {
            this.error = undefined;
            if (data.fields.TECH_FormCompleted__c.value) {
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

    @wire(getPicklistValuesByRecordType, { objectApiName: CASE_OBJECT, recordTypeId: '$recordTypeId' })
    setOptions({ error, data }) {
        if (error) {
            this.error = error;
            this.options = undefined;
        }
        else if (data) {
            this.error = undefined;
            this.options = data.picklistFieldValues.SenderType__c.values;
        }
    }

    @wire(getRecordTypeName, { recordTypeId: '$recordTypeId' })
    setFloor({ error, data }) {
        if (error) {
            this.error = error;
            this.floor = undefined;
        }
        else if (data) {
            this.error = undefined;
            this.floor = data;
            if (this.floor === 'F2MLServices') {
                this.senderType = 'Customer';
                this.template.querySelector('lightning-combobox.sender-type-combobox').classList.add('slds-hide');
            }
        }
    }

    @wire(getMetadata, { floor: '$floor', senderType: '$senderType' })
    setFields({ error, data }) {
        if (error) {
            this.error = error;
            this.visibleFields = undefined;
            this.requiredFieldsBase = undefined;
            this.template.querySelector('.form-bottom').classList.add('slds-hide');
        }
        else if (data) {
            this.error = undefined;
            if (data[0] && data[0].VisibleFields__c) {
                this.visibleFields = data[0].VisibleFields__c.replace(/\s/g, '').split(";");
                this.template.querySelector('.form-bottom').classList.remove('slds-hide');
            }
            if (data[0] && data[0].RequiredFields__c) {
                this.requiredFieldsBase = data[0].RequiredFields__c.replace(/\s/g, '').split(";");
                this.requiredFields = this.requiredFieldsBase;
            }
        }
        if (this.senderType) {
            this.isLoaded = true;
        }
    }

    @wire(getRequiredFieldsExtra, { floor: '$floor', requestType: '$requestType' })
    getRequiredFieldsByRequestType({ error, data }) {
        var requiredFieldsExtra;
        if (error) {
            this.error = error;
        }
        else if (data) {
            this.error = undefined;
            requiredFieldsExtra = data.replace(/\s/g, '').split(";");
            this.setRequiredFieldsByRequestType(requiredFieldsExtra);
        }
    }

    renderedCallback() {
        var descriptionInput = this.template.querySelector('lightning-input-field[data-item=\'Description\']');
        if (this.description && descriptionInput) {
            descriptionInput.value = this.description;
        }
    }

    setRequiredFieldsByRequestType(requiredFieldsExtra) {
        var temp = this.template;
        // Get base required fields by floor and sender type.
        var reqFields = this.requiredFieldsBase.slice(0);
        // Add extra required fields (by request type) to the previous list.
        requiredFieldsExtra.forEach(function (requiredFieldExtra) {
            reqFields.push(requiredFieldExtra);
        });
        this.requiredFields = reqFields;
        // Re-initialize the required attribute on all inputs.
        this.visibleFields.forEach(function (visibleField) {
            var selector = 'lightning-input-field[data-item=\'' + visibleField + '\']';
            temp.querySelector(selector).required = false;
        });
        // Set required attribute to the right inputs.
        this.requiredFields.forEach(function (requiredField) {
            var selector = 'lightning-input-field[data-item=\'' + requiredField + '\']';
            temp.querySelector(selector).required = true;
        });
    }

    handleComboboxChange(event) {
        this.template.querySelector('.sender-type-input').value = event.detail.value;
        this.handleSenderTypeChange(event);
    }

    handleSenderTypeChange(event) {
        this.isLoaded = false;
        if (event.detail.value) {
            this.senderType = event.detail.value;
            this.template.querySelector('.form-bottom').classList.remove('slds-hide');
        }
        else {
            this.senderType = undefined;
            this.visibleFields = undefined;
            this.template.querySelector('.form-bottom').classList.add('slds-hide');
        }
        if (!this.senderType) {
            this.isLoaded = true;
        }
    }

    handleInputChange(event) {
        if (event.target.dataset.item === 'F2MLRequestType__c' && !event.detail.value) {
            this.requestType = undefined;
            this.setRequiredFieldsByRequestType([]);
        }
        else if (event.target.dataset.item === 'F2MLRequestType__c') {
            this.requestType = event.detail.value;
        }
    }

    handleLoad() {
        var temp = this.template;
        if (this.formCompleted) {
            this.message = this.label.formAlreadySent;
            temp.querySelector('.error-frame').classList.remove('slds-hide');
            temp.querySelector('lightning-record-edit-form').classList.add('slds-hide');
        }
        else if (!this.recordId || !this.recordTypeId) {
            this.message = this.label.noRequestForThisUrl;
            temp.querySelector('.error-frame').classList.remove('slds-hide');
            temp.querySelector('lightning-record-edit-form').classList.add('slds-hide');
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

    handleSuccess() {
        this.template.querySelector('lightning-record-edit-form').classList.add('slds-hide');
        this.template.querySelector('p').classList.remove('slds-hide');
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
                    this.message = result;
                    this.template.querySelector('.error-frame').classList.remove('slds-hide');
                }
                this.isLoaded = true;
            })
            .catch(error => {
                this.error = error;
                this.message = undefined;
                this.isLoaded = true;
            });
    }

}