const test = "test99999"

 describe('Create and Edit a milestone', () => {
 beforeEach(() => {
       cy.visit('http://localhost:4000/backcast/' + test)
     })

    it('can create a milestone', () => {
        cy.get('.add-milestone').click({force: true})
        cy.wait(2000)
        cy.get('#vals_title').type("A mile stone")
        cy.get('#vals_date').clear().type("2021-11-17")
        cy.get('.milestone-submit').click({force: true})
    })

    it('can edit a milestone', () => {
     let edit_button = cy.get(".edit-milestone").first().click({force: true});
     cy.wait(2000)
     cy.get('#vals_title').clear().type("Updated milestone")
     cy.get('#vals_date').clear().type("2021-11-17")
     cy.get('.milestone-submit').click({force: true})
    })

})