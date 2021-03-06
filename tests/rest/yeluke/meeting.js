/* global describe it before */
const common = require('../common.js');


const {
    restService,
} = common;

describe('meetings API endpoint', () => {
    before((done) => {
        common.resetdb();
        done();
    });

    it('should be selectable', (done) => {
        restService()
            .get('/meetings?select=slug')
            .expect('Content-Type', /json/)
            .expect(200, done)
            .expect((r) => {
                r.body.length.should.equal(4);
            });
    });

    const newMeeting = {
        slug: 'new-meeting',
        summary: 'summary_2_2_2',
        description: 'description_1_',
        begins_at: '2017-12-27T14:54:50+00:00',
        duration: '00:00:03',
        is_draft: false,
        created_at: '2017-12-27T14:54:50+00:00',
        updated_at: '2017-12-27T22:09:47.089125+00:00',
    };

    it('should not accept other HTTP verbs', (done) => {
        restService()
            .post('/meetings')
            .send(newMeeting)
            .expect(401, done);
    });

    it('should not accept invalid POST requests', (done) => {
        restService()
            .post('/meetings')
            .send({})
            .expect(401, done);
    });
});
