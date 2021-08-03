const test = "testEEE"
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

 describe('Create and Edit a milestone', () => {
 beforeEach(() => {
       cy.visit('http://localhost:4000/backcast/' + test)
     })

    it('can create a milestone', () => {
        cy.get('.add-milestone').click({force: true})
        cy.wait(wait)
        cy.get('#vals_title').type("A new Milestone")
        cy.get('#vals_date').clear().type("2021-11-17")
        cy.get('.milestone-submit').click({force: true})
        cy.wait(wait)
    })

    it('can edit a milestone', () => {
     let edit_button = cy.get(".edit-milestone").first().click({force: true});
     cy.wait(wait)
     cy.get('#vals_title').clear().type("Updated milestone")
     cy.get('#vals_date').clear().type("2021-11-17")
     cy.get('.milestone-submit').click({force: true})
     cy.wait(wait)
    })

})