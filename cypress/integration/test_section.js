const test = "test99999"

describe('Create and Edit a section', () => {

    beforeEach(() => {
      cy.visit('http://localhost:4000/backcast/' + test)
    })



     it('can create a section', () => {
        cy.get('#add-section-btn').click({force: true})
        cy.wait(2000)
        cy.get(".create-section-btn").first().click()
     })


     it('can edit a section', () => {
         let edit_button = cy.get(".edit-section").first().click({force: true});
         cy.wait(2000)
         cy.get("#vals_new_value").wait(2000).clear().type("Example section")
         cy.get(".update-section").click({force: true})
        })

 })
