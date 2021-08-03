const test = "testA"
const wait = 5000

describe('Create and Edit a section', () => {

    beforeEach(() => {
      cy.visit('http://localhost:4000/backcast/' + test)
    })

     it('can create a section', () => {
        cy.get('#add-section-btn').click({force: true})
        cy.wait(wait)
        cy.get(".create-section-btn").first().click({force: true})
        cy.wait(wait)
     })

     it('can edit a section', () => {
         let edit_button = cy.get(".edit-section").first().click({force: true});
         cy.wait(wait)
         cy.get("#vals_new_value").wait(wait).clear().type("Edited section")
         cy.get(".update-section").click({force: true})
         cy.wait(wait)
        })

 })